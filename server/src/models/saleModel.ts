import mongoose from 'mongoose';
import { ISale } from '../interfaces/models.interface.js';

const saleSchema = new mongoose.Schema<ISale>({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    products: [
        {
            productId: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Product',
                required: true,
            },
            quantity: {
                type: Number,
                required: true,
                min: 1,
            },
        },
    ],
    total: {
        type: Number,
        required: true,
        min: 0,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        required: true,
    },
});

saleSchema.index({ userId: 1, createdAt: -1 });
saleSchema.index({ "products.productId": 1 });
saleSchema.index({ userId: 1, "products.productId": 1, createdAt: -1 });
saleSchema.index({ createdAt: -1 });
saleSchema.index({ userId: 1, total: 1, createdAt: -1 });
saleSchema.index({ "products.quantity": -1, userId: 1 });

const Sale = mongoose.model('Sale', saleSchema);

export default Sale;
