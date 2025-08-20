import mongoose from "mongoose";
import { INote } from "../interfaces/models.interface.js";

const noteSchema = new mongoose.Schema<INote>({
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
    description: {
        type: String,
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

noteSchema.index({ userId: 1, createdAt: -1 });
noteSchema.index({ title: 1, userId: 1 }, { unique: true });

const Note = mongoose.model("Note", noteSchema);

export default Note;