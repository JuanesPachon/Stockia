import { Types } from "mongoose";

export interface IUser {
    name: string;
    email: string;
    password: string;
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