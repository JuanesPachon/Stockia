import multer from 'multer';
import { Request, Response, NextFunction } from 'express';
import { decode } from 'base64-arraybuffer';
import path from 'path';
import mongoose from 'mongoose';
import 'dotenv/config';
import { IUploadResult, IMulterFile } from '../interfaces/multer.interface.js';
import { supabaseClient } from '../config/multer.config.js';
import Product from '../models/productModel.js';

const createUploadResult = (
    success: boolean,
    error?: 'invalid_file' | 'upload_failed' | 'server',
    message?: string,
    data?: string
): IUploadResult => {
    return { success, error, message, data };
};

const handleMulterError = (error: any, _req: Request, res: Response, next: NextFunction): void => {
    if (error instanceof multer.MulterError || error.message === 'File is not in a valid format') {
        const result = createUploadResult(false, 'invalid_file', error.message || 'Invalid file');
        res.status(400).json(result);
        return;
    }
    next(error);
};

const uploadToSupabase = async (req: Request, res: Response, next: NextFunction): Promise<void | Response> => {
    if (!req.file) {
        return next();
    }

    try {
        const { originalname, buffer } = req.file;
        const filePath = `${Date.now()}-${originalname}`;
        const fileBase64 = decode(buffer.toString('base64'));

        const { error } = await supabaseClient.storage.from('stockia_files').upload(filePath, fileBase64, {
            contentType: 'image/' + path.extname(originalname).substring(1),
        });

        if (error) {
            console.error('Error al subir la imagen a Supabase:', error);
            const result = createUploadResult(false, 'upload_failed', 'Error uploading image to Supabase');
            return res.status(500).json(result);
        }

        (req.file as IMulterFile).supabaseUrl = filePath;
        req.body.imageUrl = filePath;

        next();
    } catch (uploadError) {
        console.error('Error inesperado al subir la imagen:', uploadError);
        const result = createUploadResult(false, 'server', 'Error processing image');
        return res.status(500).json(result);
    }
};

const deleteOldImage = async (req: Request, _res: Response, next: NextFunction): Promise<void | Response> => {
    try {
        if (!req.file) {
            return next();
        }

        const productId = req.params.id;
        if (!productId || !mongoose.Types.ObjectId.isValid(productId)) {
            return next();
        }

        const existingProduct = await Product.findById(productId);

        if (existingProduct && existingProduct.imageUrl) {
            const oldImageUrl = existingProduct.imageUrl;

            const supabasePathRegex = /^\d+-[a-zA-Z0-9\-._]+\.(jpg|jpeg|png|gif|webp)$/i;

            if (supabasePathRegex.test(oldImageUrl)) {
                const { error } = await supabaseClient.storage.from('stockia_files').remove([oldImageUrl]);

                if (error) {
                    console.error('Error al eliminar imagen anterior:', error);
                }
            }
        }

        next();
    } catch (error) {
        next();
    }
};

export { handleMulterError, uploadToSupabase, deleteOldImage };
