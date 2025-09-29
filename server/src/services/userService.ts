import bcrypt from 'bcryptjs';
import { IUser } from '../interfaces/models.interface.js';
import { ICreateAndEditResult, IGetResult, ILoginResult, IRegisterResult } from '../interfaces/database.interface.js';
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
            message: 'Error occurred while registering user',
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

const getUserById = async (id: string): Promise<IGetResult> => {
    try {
        const user = await User.findById(id).select('-password');
        if (!user) {
            return {
                success: false,
                error: 'not_found',
                message: 'User not found',
            };
        }

        return {
            success: true,
            message: 'User retrieved successfully',
            data: user,
        };
    } catch (error) {
        return {
            success: false,
            error: 'server',
            message: 'Error occurred while retrieving user',
        };
    }
};

const editUser = async (id: string, userData: Partial<IUser>): Promise<ICreateAndEditResult> => {
    try {

        const user = await User.findById(id);
        if (!user) {
            return {
                success: false,
                error: 'not_found',
                message: 'User not found',
            };
        }
        if (userData.password) {
            userData.password = await bcrypt.hash(userData.password, 10);
        }
        await User.findByIdAndUpdate(id, userData);
        return {
            success: true,
            message: 'User updated successfully',
        };
    } catch (error) {
        return {
            success: false,
            error: 'server',
            message: 'Error occurred while updating user',
        };
    }
};

export default {
    createUser,
    loginUser,
    getUserById,
    editUser,
};
