import { Request, Response } from 'express';
import saleService from '../services/saleService.js';
import errorHandler from '../utils/errorHandler.js';

const getSalesController = async (req: Request, res: Response) => {
    try {
        const userId = req.user?.sub;
        const orderQuery = req.query.order;
        const timeRangeQuery = req.query.timeRange;
        const productIdQuery = req.query.productId;
        const categoryIdQuery = req.query.categoryId;
        
        const order = typeof orderQuery === 'string' ? orderQuery : 'desc';
        const timeRange = typeof timeRangeQuery === 'string' ? timeRangeQuery : undefined;
        const productId = typeof productIdQuery === 'string' ? productIdQuery : undefined;
        const categoryId = typeof categoryIdQuery === 'string' ? categoryIdQuery : undefined;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await saleService.getSales(userId, order, timeRange, productId, categoryId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'User not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const getSaleController = async (req: Request, res: Response) => {
    try {
        const saleId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await saleService.getSaleById(saleId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Sale not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const createSaleController = async (req: Request, res: Response) => {
    try {
        const saleData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await saleService.createSale(saleData, userId);

        if (response.success) {
            return res.status(201).json(response);
        } else if (response.error === 'not_found' && response.message === 'One or more products not found or do not belong to the user') {
            return res.status(404).json(response);
        } else if (response.message === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'User not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

export {
    getSalesController,
    getSaleController,
    createSaleController,
};
