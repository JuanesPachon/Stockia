import { Request, Response } from 'express';
import userService from '../services/userService.js';
import errorHandler from '../utils/errorHandler.js';

const registerController = async (req: Request, res: Response) => {
    try {
        const user = req.body;

        const response = await userService.createUser(user);

        if (response.success) {
            return res.status(201).json(response);
        } else if (response.error === 'duplicate') {
            return errorHandler.handleDuplicateError(res, response.message);
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const loginController = async (req: Request, res: Response) => {
    try {
        const loginRequest = req.body;

        const response = await userService.loginUser(loginRequest);

        if (response.success) {
            return res
                .cookie('access_token', response.token, {
                    httpOnly: true,
                    secure: process.env.NODE_ENV === 'production',
                    sameSite: 'lax',
                    maxAge: 14 * 24 * 60 * 60 * 1000,
                })
                .status(200)
                .json({
                    success: true,
                    message: response.message,
                });
        } else if (response.error === 'invalid_credentials') {
            return errorHandler.handleInvalidCredentialsError(res);
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const logoutController = async (req: Request, res: Response) => {};

export { registerController, loginController, logoutController };
