import mongoose from 'mongoose';
import { IProduct } from '../interfaces/models.interface.js';

const productSchema = new mongoose.Schema<IProduct>({
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
    providerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Provider',
        required: false,
        default: null,
    },
    stock: {
        type: Number,
        required: true,
        default: 0,
    },
    price: {
        type: Number,
        required: true,
        default: 0,
    },
    imageUrl: {
        type: String,
        required: false,
        default: null,
    },
});

// Index for optimizing queries
productSchema.index({ categoryId: 1, name: 1 }, { unique: true });

const Product = mongoose.model('Product', productSchema);

export default Product;
