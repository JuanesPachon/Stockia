import { Request, Response } from 'express';
import errorHandler from '../utils/errorHandler.js';
import productService from '../services/productService.js';

const getProductsController = async (req: Request, res: Response) => {
    try {
        const userId = req.user?.sub;
        const orderQuery = req.query.order;
        const categoryIdQuery = req.query.categoryId;
        
        const order = typeof orderQuery === 'string' ? orderQuery : 'desc';
        const categoryId = typeof categoryIdQuery === 'string' ? categoryIdQuery : undefined;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await productService.getProducts(userId, order, categoryId);

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

const getProductController = async (req: Request, res: Response) => {
    try {
        const productId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await productService.getProductById(productId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Product not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const createProductController = async (req: Request, res: Response) => {
    try {
        const productData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await productService.createProduct(productData, userId);

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
        return errorHandler.handleServerError(res);
    }
};

const updateProductController = async (req: Request, res: Response) => {
    try {
        const productId = req.params.id;
        const productData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await productService.updateProduct(productId, productData, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Product not found');
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const deleteProductController = async (req: Request, res: Response) => {
    try {
        const productId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await productService.deleteProduct(productId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Product not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

export { 
    getProductsController,
    getProductController,
    createProductController,
    updateProductController,
    deleteProductController
};
