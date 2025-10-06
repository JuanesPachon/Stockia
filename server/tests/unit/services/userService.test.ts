import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import bcrypt from 'bcryptjs';
import mongoose from 'mongoose';
import userService from '../../../src/services/userService.js';
import User from '../../../src/models/userModel.js';
import { IUser } from '../../../src/interfaces/models.interface.js';
import { Auth } from '../../../src/interfaces/auth.interface.js';
import { setupTestDB, teardownTestDB, clearDatabase } from '../../setup.js';

describe('Tests Unitarios de UserService', () => {
  beforeAll(async () => {
    await setupTestDB();
    process.env.JWT_SECRET = 'test-jwt-secret';
  });

  afterAll(async () => {
    await teardownTestDB();
  });

  beforeEach(async () => {
    await clearDatabase();
  });

  describe('Registro de Usuario', () => {
    it('debería registrar un nuevo usuario exitosamente', async () => {
      // Arrange
      const userData: IUser = {
        name: 'Usuario Test',
        email: 'test@test.com',
        password: 'password123',
        businessName: 'Negocio Test',
        createdAt: new Date()
      };

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result.success).toBe(true);
      expect(result.message).toBe('User registered successfully');
      
      // Verificar que la contraseña fue hasheada
      const createdUser = await User.findOne({ email: userData.email });
      expect(createdUser?.password).not.toBe(userData.password);
      
      const isValidHash = await bcrypt.compare(userData.password, createdUser!.password);
      expect(isValidHash).toBe(true);
    });

    it('debería retornar error cuando el email ya existe', async () => {
      // Arrange
      const userData: IUser = {
        name: 'Usuario Test',
        email: 'duplicate@test.com',
        password: 'password123',
        businessName: 'Negocio Test',
        createdAt: new Date()
      };

      // Crear usuario existente
      await User.create({
        ...userData,
        password: await bcrypt.hash(userData.password, 10)
      });

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result.success).toBe(false);
      expect(result.error).toBe('duplicate');
      expect(result.message).toBe('Email already exists');
    });
  });

  describe('Autenticación de Usuario', () => {
    beforeEach(async () => {
      // Crear un usuario de prueba para los tests de login
      const hashedPassword = await bcrypt.hash('password123', 10);
      await User.create({
        name: 'Usuario Test',
        email: 'login@test.com',
        password: hashedPassword,
        businessName: 'Negocio Test',
        createdAt: new Date()
      });
    });

    it('debería autenticar usuario con credenciales válidas', async () => {
      // Arrange
      const loginData: Auth = {
        email: 'login@test.com',
        password: 'password123'
      };

      // Act
      const result = await userService.loginUser(loginData);

      // Assert
      expect(result.success).toBe(true);
      expect(result.message).toBe('Login successful');
      expect(result.token).toBeTruthy();
      expect(typeof result.token).toBe('string');
    });

    it('debería retornar error con credenciales inválidas', async () => {
      // Arrange
      const loginData: Auth = {
        email: 'wrong@test.com',
        password: 'wrongpassword'
      };

      // Act
      const result = await userService.loginUser(loginData);

      // Assert
      expect(result.success).toBe(false);
      expect(result.error).toBe('invalid_credentials');
      expect(result.message).toBe('Invalid credentials');
    });
  });

  describe('CRUD de Usuario', () => {
    let testUserId: string;

    beforeEach(async () => {
      // Crear usuario de prueba
      const testUser = await User.create({
        name: 'Usuario Test',
        email: 'crud@test.com',
        password: await bcrypt.hash('password123', 10),
        businessName: 'Negocio Test',
        createdAt: new Date()
      });
      testUserId = testUser._id.toString();
    });

    it('debería obtener usuario por ID exitosamente', async () => {
      // Act
      const result = await userService.getUserById(testUserId);

      // Assert
      expect(result.success).toBe(true);
      expect(result.message).toBe('User retrieved successfully');
      expect(result.data).toBeTruthy();
      
      const userData = result.data as any;
      expect(userData.email).toBe('crud@test.com');
      expect(userData.password).toBeFalsy(); // La contraseña no debe incluirse
    });

    it('debería actualizar usuario exitosamente', async () => {
      // Arrange
      const updateData: Partial<IUser> = {
        name: 'Usuario Actualizado',
        businessName: 'Negocio Actualizado'
      };

      // Act
      const result = await userService.editUser(testUserId, updateData);

      // Assert
      expect(result.success).toBe(true);
      expect(result.message).toBe('User updated successfully');
      
      // Verificar que los datos fueron actualizados
      const updatedUser = await User.findById(testUserId);
      expect(updatedUser?.name).toBe(updateData.name);
      expect(updatedUser?.businessName).toBe(updateData.businessName);
    });
  });
});