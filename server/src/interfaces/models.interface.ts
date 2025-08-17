import { Types } from "mongoose";
import { Auth } from "./auth.interface.js";

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