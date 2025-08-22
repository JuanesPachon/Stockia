import { ICreateAndEditResult, IGetResult } from '../interfaces/database.interface.js';
import { ISale } from '../interfaces/models.interface.js';
import Sale from '../models/saleModel.js';
import User from '../models/userModel.js';
import Product from '../models/productModel.js';

const getSales = async (
    userId: string, 
    order: string = 'desc', 
    timeRange?: string,
    productId?: string,
    categoryId?: string
): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
                message: 'User not found',
            };
        }

        const sortOrder = order === 'asc' ? 1 : -1;
        const sortObject: any = {};
        sortObject['createdAt'] = sortOrder;

        const filters: any = { 
            userId: userId
        };

        if (timeRange) {
            const now = new Date();
            let startDate: Date;

            switch (timeRange) {
                case 'today':
                    startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                    break;
                case '1week':
                    startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                    break;
                case '1month':
                    startDate = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
                    break;
                case '3months':
                    startDate = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                    break;
                case '1year':
                    startDate = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
                    break;
                default:
                    startDate = new Date(0);
            }

            if (timeRange !== 'all') {
                filters.createdAt = { $gte: startDate };
            }
        }

        if (productId) {
            filters['products.productId'] = productId;
        }

        const sales = await Sale.find(filters)
            .sort(sortObject)
            .populate({
                path: 'products.productId',
                select: 'name price categoryId',
                populate: {
                    path: 'categoryId',
                    select: 'name'
                }
            });

        let filteredSales = sales;
        if (categoryId) {
            filteredSales = sales.filter(sale => 
                sale.products.some((product: any) => 
                    product.productId?.categoryId?._id?.toString() === categoryId
                )
            );
        }

        return {
            success: true,
            message: 'Sales retrieved successfully',
            data: filteredSales,
        };
    } catch (error) {
        console.error('Error fetching sales:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the sales',
        };
    }
};

const getSaleById = async (saleId: string, userId: string): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const sale = await Sale.findOne({
            _id: saleId,
            userId: userId,
        })
        .populate({
            path: 'products.productId',
            select: 'name price categoryId',
            populate: {
                path: 'categoryId',
                select: 'name description'
            }
        });

        if (!sale) {
            return {
                success: false,
                error: 'not_found',
                message: 'Sale not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Sale retrieved successfully',
            data: sale,
        };
    } catch (error) {
        console.error('Error fetching sale:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the sale',
        };
    }
};

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
    getSales,
    getSaleById,
    createSale,
};
