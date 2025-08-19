import { Router } from 'express';
import { createProductController, deleteProductController, updateProductController } from '../controllers/productControllers.js';
import { upload } from '../config/multer.config.js';
import { handleMulterError, uploadToSupabase, deleteOldImage } from '../middlewares/multerMiddlewares.js';
import { editProductValidations, productValidations } from '../middlewares/validateProduct.js';
import errorsIsEmpty from '../middlewares/errorIsEmpty.js';
import verifyToken from '../middlewares/validateToken.js';

const router = Router();

router.use(verifyToken);

router.post('/products', upload.single('imageUrl'), handleMulterError, uploadToSupabase, productValidations, errorsIsEmpty, createProductController);
router.patch('/products/:id', upload.single('imageUrl'), handleMulterError, deleteOldImage, uploadToSupabase, editProductValidations, errorsIsEmpty, updateProductController);
router.delete("/products/:id", deleteProductController);

export default router;
