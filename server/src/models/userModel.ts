import mongoose from 'mongoose';
import { IUser } from '../interfaces/models.interface.js';

const userShema = new mongoose.Schema<IUser>({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    businessName: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        required: true,
    },
});

// Index for optimizing queries
userShema.index({ email: 1 }, { unique: true });

const User = mongoose.model('User', userShema);

export default User;
