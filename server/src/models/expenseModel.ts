import mongoose from "mongoose";
import { IExpense } from "../interfaces/models.interface.js";

const expenseSchema = new mongoose.Schema<IExpense>({
    
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    title: {
        type: String,
        required: true,
    },
    categoryId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Category",
        required: false,
        default: null,
    },
    amount: {
        type: Number,
        required: true,
    },
    providerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Provider",
        required: false,
        default: null,
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

expenseSchema.index({ userId: 1, createdAt: -1 });
expenseSchema.index({ title: 1, userId: 1 }, { unique: true, partialFilterExpression: { deletedAt: null } });

const Expense = mongoose.model("Expense", expenseSchema);

export default Expense;