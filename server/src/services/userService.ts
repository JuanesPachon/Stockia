import bcrypt from "bcryptjs";
import { IUser } from "../interfaces/models.interface.js";
import { RegisterResult } from "../interfaces/database.interface.js";
import User from "../models/userModel.js";

const createUser = async (user: IUser): Promise<RegisterResult> => {
    try {

        const existingUser = await User.exists({ email: user.email });
        if (existingUser) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Email already exists',
            };
        }

        const hashedPassword = await bcrypt.hash(user.password, 10);

        await User.create({
            ...user,
            password: hashedPassword,
        });

        return {
            success: true,
            message: 'User registered successfully',
        };

    } catch (error) {

        return {
            success: false,
            error: 'server',
            message: 'Internal server error',
        }
        
    }
}

export default {
    createUser,
};