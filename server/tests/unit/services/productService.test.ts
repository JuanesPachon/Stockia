import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { setupTestDB, teardownTestDB, clearDatabase } from '../../setup.js';
import productService from '../../../src/services/productService.js';
import Product from '../../../src/models/productModel.js';
import { IProduct } from '../../../src/interfaces/models.interface.js';
import { Types } from 'mongoose';

describe('Tests Unitarios de ProductService', () => {
    let testUserId: string;
    let testCategoryId: string;
    let testProviderId: string;

    beforeAll(async () => {
        await setupTestDB();
    });

    afterAll(async () => {
        await teardownTestDB();
    });

    beforeEach(async () => {
        await clearDatabase();
        
        // Crear IDs válidos para los tests
        testUserId = new Types.ObjectId().toString();
        testCategoryId = new Types.ObjectId().toString();
        testProviderId = new Types.ObjectId().toString();
    });

    describe('Creación de Producto', () => {
        it('debería fallar con usuario inexistente', async () => {
            // Arrange
            const productData: IProduct = {
                name: 'Producto Test',
                price: 100,
                stock: 50,
                categoryId: new Types.ObjectId(testCategoryId),
                providerId: new Types.ObjectId(testProviderId),
                userId: new Types.ObjectId(testUserId),
                imageUrl: null,
                createdAt: new Date(),
                deletedAt: null
            };

            // Act
            const result = await productService.createProduct(productData, testUserId);

            // Assert
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Obtener Productos', () => {
        it('debería fallar al obtener productos con usuario inexistente', async () => {
            // Act
            const result = await productService.getProducts(testUserId);

            // Assert
            expect(result.success).toBe(false);
            expect(result.error).toBe('not_found');
            expect(result.message).toBe('User not found');
        });
    });
});