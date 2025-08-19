import { Types } from 'mongoose';
import { Auth } from './auth.interface.js';

export interface IUser extends Auth {
    name: string;
    businessName: string;
    createdAt: Date;
}

export interface ICategory {
    userId: Types.ObjectId;
    name: string;
    description: string;
    createdAt: Date;
    deletedAt: Date | null;
}

export interface IProduct {
    userId: Types.ObjectId;
    name: string;
    categoryId: Types.ObjectId | null;
    providerId?: Types.ObjectId | null;
    stock: number;
    price: number;
    imageUrl?: string | null;
    createdAt: Date;
    deletedAt: Date | null;
}
