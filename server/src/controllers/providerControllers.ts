import { Request, Response } from 'express';
import providerService from '../services/providerService.js';
import errorHandler from '../utils/errorHandler.js';

const getProvidersController = async (req: Request, res: Response) => {
    try {
        const userId = req.user?.sub;
        const orderQuery = req.query.order;
        const categoryIdQuery = req.query.categoryId;
        
        const order = typeof orderQuery === 'string' ? orderQuery : 'desc';
        const categoryId = typeof categoryIdQuery === 'string' ? categoryIdQuery : undefined;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await providerService.getProviders(userId, order, categoryId);

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

const getProviderController = async (req: Request, res: Response) => {
    try {
        const providerId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await providerService.getProviderById(providerId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Provider not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const createProviderController = async (req: Request, res: Response) => {
    try {
        const providerData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await providerService.createProvider(providerData, userId);

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

const updateProviderController = async (req: Request, res: Response) => {
    try {
        const providerId = req.params.id;
        const providerData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await providerService.updateProvider(providerId, providerData, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Provider not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const deleteProviderController = async (req: Request, res: Response) => {
    try {
        const providerId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await providerService.deleteProvider(providerId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Provider not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

export {
    getProvidersController,
    getProviderController,
    createProviderController,
    updateProviderController,
    deleteProviderController,
};