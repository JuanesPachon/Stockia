import { describe, test, expect, beforeEach, vi, afterEach } from 'vitest';
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import verifyToken from '../../../src/middlewares/validateToken.js';

// Mock jwt
vi.mock('jsonwebtoken');

describe('Tests Unitarios de ValidateToken Middleware', () => {
    let mockRequest: any;
    let mockResponse: any;
    let mockNext: NextFunction;

    beforeEach(() => {
        mockRequest = {
            cookies: {},
            user: undefined
        };

        mockResponse = {
            status: vi.fn().mockReturnThis(),
            json: vi.fn().mockReturnThis()
        };

        mockNext = vi.fn();
        process.env.JWT_SECRET = 'test-secret';
        vi.clearAllMocks();
    });

    afterEach(() => {
        vi.restoreAllMocks();
    });

    test('debería permitir acceso con token válido', () => {
        const validToken = 'valid-jwt-token';
        const decodedToken = {
            sub: 'user123',
            iat: Date.now()
        };

        mockRequest.cookies = { access_token: validToken };
        (jwt.verify as any).mockReturnValue(decodedToken);

        verifyToken(mockRequest as Request, mockResponse as Response, mockNext);

        expect(jwt.verify).toHaveBeenCalledWith(validToken, 'test-secret');
        expect(mockRequest.user).toEqual(decodedToken);
        expect(mockNext).toHaveBeenCalledOnce();
        expect(mockResponse.status).not.toHaveBeenCalled();
        expect(mockResponse.json).not.toHaveBeenCalled();
    });

    test('debería retornar error 401 cuando no hay token', () => {
        mockRequest.cookies = {}; // No token

        verifyToken(mockRequest as Request, mockResponse as Response, mockNext);

        expect(mockResponse.status).toHaveBeenCalledWith(401);
        expect(mockResponse.json).toHaveBeenCalledWith({
            success: false,
            message: 'Access token required'
        });
        expect(mockNext).not.toHaveBeenCalled();
        expect(jwt.verify).not.toHaveBeenCalled();
    });

    test('debería retornar error 401 cuando el token es inválido', () => {
        const invalidToken = 'invalid-token';
        mockRequest.cookies = { access_token: invalidToken };

        const jsonWebTokenError = new jwt.JsonWebTokenError('Invalid token');
        (jwt.verify as any).mockImplementation(() => {
            throw jsonWebTokenError;
        });

        verifyToken(mockRequest, mockResponse, mockNext);

        expect(jwt.verify).toHaveBeenCalledWith(invalidToken, 'test-secret');
        expect(mockResponse.status).toHaveBeenCalledWith(401);
        expect(mockResponse.json).toHaveBeenCalledWith({
            success: false,
            message: 'Invalid token'
        });
        expect(mockNext).not.toHaveBeenCalled();
    });
});