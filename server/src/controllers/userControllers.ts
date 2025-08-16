import { Request, Response } from "express"
import userService from "../services/userService.js";
import errorHandler from "../utils/errorHandler.js";


const registerController = async (req: Request, res: Response) => {
    try {
        
        const user = req.body;

        const response = await userService.createUser(user);

        console.log(response);
        

        if(response.success) {
            return res.status(201).json({
                success: true,
                message: response.message,
            });
        } else if(response.error === 'duplicate') {
            return res.status(409).json({
                success: false,
                message: response.message,
            });
        } else {
            return errorHandler.handleServerError(res);
        }

    } catch (error) {
        return errorHandler.handleServerError(res);
    }
}

const loginController = async (req: Request, res: Response) => {

}

const logoutController = async (req: Request, res: Response) => {

}

export {
    registerController,
    loginController,
    logoutController
}