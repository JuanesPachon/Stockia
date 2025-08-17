import bcrypt from 'bcryptjs';
import { IUser } from '../interfaces/models.interface.js';
import { ILoginResult, IRegisterResult } from '../interfaces/database.interface.js';
import User from '../models/userModel.js';
import { Auth } from '../interfaces/auth.interface.js';
import jwt from 'jsonwebtoken';

const createUser = async (user: IUser): Promise<IRegisterResult> => {
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
        };
    }
};

const loginUser = async (loginRequest: Auth): Promise<ILoginResult> => {
    try {
        const user = await User.findOne({ email: loginRequest.email });
        const passwordMatch = user ? await bcrypt.compare(loginRequest.password, user.password) : false;

        if (!user || !passwordMatch) {
            return {
                success: false,
                error: 'invalid_credentials',
                message: 'Invalid credentials',
            };
        }

        const tokenPayload = {
            sub: user._id,
        };

        const token = jwt.sign(tokenPayload, process.env.JWT_SECRET as string, {
            expiresIn: '14d',
        });

        return {
            success: true,
            message: 'Login successful',
            token,
        };
    } catch (error) {
        return {
            success: false,
            error: 'server',
            message: 'Internal server error',
        };
    }
};

export default {
    createUser,
    loginUser,
};
