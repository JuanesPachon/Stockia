import mongoose from "mongoose";
import { ICategory } from "../interfaces/models.interface.js";

const categorySchema = new mongoose.Schema<ICategory>({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        required: false,
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
categorySchema.index({ userId: 1, createdAt: -1 });
categorySchema.index({ name: 1, userId: 1 }, { unique: true });

const Category = mongoose.model("Category", categorySchema);


export default Category;