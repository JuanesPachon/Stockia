import { ICreateAndEditResult } from '../interfaces/database.interface.js';
import { ISale } from '../interfaces/models.interface.js';
import Sale from '../models/saleModel.js';
import User from '../models/userModel.js';
import Product from '../models/productModel.js';

const createSale = async (saleData: ISale, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        for (const item of saleData.products) {
            const existingProduct = await Product.exists({
                _id: item.productId,
                userId: userId,
                deletedAt: null,
            });

            if (!existingProduct) {
                return {
                    success: false,
                    error: 'not_found',
                    message: 'One or more products not found or do not belong to the user',
                };
            }
        }

        const newSale = {
            ...saleData,
            userId: userId,
        };

        const createdSale = await Sale.create(newSale);

        return {
            success: true,
            message: 'Sale created successfully',
            data: {
                id: createdSale._id,
                products: createdSale.products,
                total: createdSale.total,
                createdAt: createdSale.createdAt,
            },
        };
    } catch (error) {
        console.error('Error creating sale:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the sale',
        };
    }
};

export default {
    createSale,
};
