import { Request, Response } from 'express';
import saleService from '../services/saleService.js';
import errorHandler from '../utils/errorHandler.js';

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
    createSaleController,
};
