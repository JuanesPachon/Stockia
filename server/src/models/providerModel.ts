import mongoose from 'mongoose';
import { IProvider } from '../interfaces/models.interface.js';

const providerSchema = new mongoose.Schema<IProvider>({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    categoryId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Category',
        required: false,
        default: null,
    },
    contact: {
        type: String,
        required: false,
    },
    description: {
        type: String,
        required: false,
    },
    status: {
        type: Boolean,
        default: true,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        required: true,
    },
    deletedAt: {
        type: Date,
        default: null,
        required: false,
    },
});

// Index for optimizing queries
providerSchema.index({ userId: 1, createdAt: -1 });
providerSchema.index({ name: 1, userId: 1 }, { unique: true });

const Provider = mongoose.model('Provider', providerSchema);

export default Provider;
