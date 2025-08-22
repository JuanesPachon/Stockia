import { Request, Response } from 'express';
import expenseService from '../services/expenseService.js';
import errorHandler from '../utils/errorHandler.js';

const createExpenseController = async (req: Request, res: Response) => {
    try {
        const expenseData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await expenseService.createExpense(expenseData, userId);

        if (response.success) {
            return res.status(201).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.error === 'not_found' && (
            response.message === 'Category not found or does not belong to the user' ||
            response.message === 'Provider not found or does not belong to the user'
        )) {
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

const editExpenseController = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const expenseData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await expenseService.updateExpense(id, expenseData, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.error === 'not_found' && (
            response.message === 'Category not found or does not belong to the user' ||
            response.message === 'Provider not found or does not belong to the user' ||
            response.message === 'Expense not found or does not belong to the user'
        )) {
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
    createExpenseController,
    editExpenseController,
};
