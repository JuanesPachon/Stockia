import { describe, test, expect, beforeAll, afterAll, beforeEach, vi, afterEach } from 'vitest';
import request from 'supertest';
import express, { Request } from 'express';
import mongoose from 'mongoose';
import { setupTestDB, teardownTestDB, clearDatabase } from '../../setup.js';
import { registerController, loginController, getUserController, editUserController } from '../../../src/controllers/userControllers.js';
import userService from '../../../src/services/userService.js';

// Extend Request interface for testing
declare module 'express-serve-static-core' {
    interface Request {
        user?: {
            sub: string;
        };
    }
}

vi.mock('../../../src/services/userService.js');

describe('User Controllers', () => {
    let app: express.Application;

    beforeAll(async () => {
        await setupTestDB();
        
        // Configurar Express app para las pruebas
        app = express();
        app.use(express.json());
        
        // Configurar rutas de prueba
        app.post('/register', registerController);
        app.post('/login', loginController);
        app.get('/user', (req, res, next) => {
            // Simular middleware de autenticación
            req.user = { sub: 'test-user-id' };
            next();
        }, getUserController);
        app.put('/user', (req, res, next) => {
            // Simular middleware de autenticación
            req.user = { sub: 'test-user-id' };
            next();
        }, editUserController);
    });

    afterAll(async () => {
        await teardownTestDB();
    });

    beforeEach(async () => {
        await clearDatabase();
        vi.clearAllMocks();
    });

    afterEach(() => {
        vi.restoreAllMocks();
    });

    describe('POST /register', () => {
        test('debería registrar un nuevo usuario exitosamente', async () => {
            const userData = {
                name: 'Test User',
                lastname: 'Test Lastname',
                email: 'test@example.com',
                password: 'testpassword123'
            };

            const mockServiceResponse = {
                success: true,
                message: 'User created successfully',
                data: { id: 'test-id', ...userData }
            };

            (userService.createUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .post('/register')
                .send(userData)
                .expect(201);

            expect(response.body).toEqual(mockServiceResponse);
            expect(userService.createUser).toHaveBeenCalledWith(userData);
        });

        test('debería retornar error 409 cuando el email ya existe', async () => {
            const userData = {
                name: 'Test User',
                lastname: 'Test Lastname', 
                email: 'existing@example.com',
                password: 'testpassword123'
            };

            const mockServiceResponse = {
                success: false,
                error: 'duplicate',
                message: 'User already exists with this email'
            };

            (userService.createUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .post('/register')
                .send(userData)
                .expect(409);

            expect(response.body.success).toBe(false);
            expect(userService.createUser).toHaveBeenCalledWith(userData);
        });

        test('debería retornar error 500 cuando hay error del servidor', async () => {
            const userData = {
                name: 'Test User',
                lastname: 'Test Lastname',
                email: 'test@example.com',
                password: 'testpassword123'
            };

            const mockServiceResponse = {
                success: false,
                error: 'server',
                message: 'An error occurred while creating the user'
            };

            (userService.createUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .post('/register')
                .send(userData)
                .expect(500);

            expect(response.body).toEqual(mockServiceResponse);
        });
    });

    describe('POST /login', () => {
        test('debería autenticar usuario exitosamente', async () => {
            const loginData = {
                email: 'test@example.com',
                password: 'testpassword123'
            };

            const mockServiceResponse = {
                success: true,
                message: 'User authenticated successfully',
                token: 'mock-jwt-token'
            };

            (userService.loginUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .post('/login')
                .send(loginData)
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.message).toBe(mockServiceResponse.message);
            expect(response.headers['set-cookie']).toBeDefined();
            expect(userService.loginUser).toHaveBeenCalledWith(loginData);
        });

        test('debería retornar error 401 con credenciales inválidas', async () => {
            const loginData = {
                email: 'test@example.com',
                password: 'wrongpassword'
            };

            const mockServiceResponse = {
                success: false,
                error: 'invalid_credentials',
                message: 'Invalid email or password'
            };

            (userService.loginUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .post('/login')
                .send(loginData)
                .expect(401);

            expect(response.body.success).toBe(false);
            expect(userService.loginUser).toHaveBeenCalledWith(loginData);
        });


    });

    describe('GET /user', () => {
        test('debería obtener información del usuario autenticado', async () => {
            const mockServiceResponse = {
                success: true,
                message: 'User retrieved successfully',
                data: {
                    id: 'test-user-id',
                    name: 'Test User',
                    lastname: 'Test Lastname',
                    email: 'test@example.com'
                }
            };

            (userService.getUserById as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .get('/user')
                .expect(200);

            expect(response.body).toEqual(mockServiceResponse);
            expect(userService.getUserById).toHaveBeenCalledWith('test-user-id');
        });

        test('debería retornar error 404 cuando el usuario no existe', async () => {
            const mockServiceResponse = {
                success: false,
                error: 'not_found',
                message: 'User not found'
            };

            (userService.getUserById as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .get('/user')
                .expect(404);

            expect(response.body.success).toBe(false);
            expect(userService.getUserById).toHaveBeenCalledWith('test-user-id');
        });
    });

    describe('PUT /user', () => {
        test('debería actualizar usuario exitosamente', async () => {
            const updateData = {
                name: 'Updated Name',
                lastname: 'Updated Lastname'
            };

            const mockServiceResponse = {
                success: true,
                message: 'User updated successfully'
            };

            (userService.editUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .put('/user')
                .send(updateData)
                .expect(200);

            expect(response.body).toEqual(mockServiceResponse);
            expect(userService.editUser).toHaveBeenCalledWith('test-user-id', updateData);
        });

        test('debería retornar error 404 cuando el usuario no existe', async () => {
            const updateData = {
                name: 'Updated Name'
            };

            const mockServiceResponse = {
                success: false,
                error: 'not_found',
                message: 'User not found'
            };

            (userService.editUser as any).mockResolvedValue(mockServiceResponse);

            const response = await request(app)
                .put('/user')
                .send(updateData)
                .expect(404);

            expect(response.body.success).toBe(false);
            expect(userService.editUser).toHaveBeenCalledWith('test-user-id', updateData);
        });

    });
});