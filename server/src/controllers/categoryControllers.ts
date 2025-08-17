import { Request, Response } from 'express';
import categoryService from '../services/categoryService.js';
import errorHandler from '../utils/errorHandler.js';

const createCategoryController = async (req: Request, res: Response) => {
    try {
        const categoryData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await categoryService.createCategory(categoryData, userId);

        if (response.success) {
            return res.status(201).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.message === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'User not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        console.error('Error in createCategoryController:', error);
        return errorHandler.handleServerError(res);
    }
};

const getCategoriesController = async (req: Request, res: Response) => {};

const getCategoryController = async (req: Request, res: Response) => {};

const updateCategoryController = async (req: Request, res: Response) => {
    try {
        const categoryId = req.params.id;
        const categoryData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await categoryService.updateCategory(categoryId, categoryData, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Category not found');
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        console.error('Error in updateCategoryController:', error);
        return errorHandler.handleServerError(res);
    }
};

const deleteCategoryController = async (req: Request, res: Response) => {};

export { createCategoryController, getCategoriesController, getCategoryController, updateCategoryController, deleteCategoryController };
