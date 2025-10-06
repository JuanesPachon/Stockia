import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { setupTestDB, teardownTestDB, clearDatabase } from '../../setup.js';
import saleService from '../../../src/services/saleService.js';
import { ISale } from '../../../src/interfaces/models.interface.js';
import { Types } from 'mongoose';

describe('Tests Unitarios de SaleService', () => {
    let testUserId: string;

    beforeAll(async () => {
        await setupTestDB();
    });

    afterAll(async () => {
        await teardownTestDB();
    });

    beforeEach(async () => {
        await clearDatabase();
        testUserId = new Types.ObjectId().toString();
    });

    describe('Creación de Venta', () => {
        it('debería fallar con usuario inexistente', async () => {
            // Arrange
            const saleData: ISale = {
                userId: new Types.ObjectId(testUserId),
                products: [
                    {
                        productId: new Types.ObjectId(),
                        quantity: 2
                    }
                ],
                total: 200,
                createdAt: new Date()
            };

            // Act
            const result = await saleService.createSale(saleData, testUserId);

            // Assert
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Obtener Ventas', () => {
        it('debería fallar al obtener ventas con usuario inexistente', async () => {
            // Act
            const result = await saleService.getSales(testUserId);

            // Assert
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });
});