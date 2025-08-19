import { Router } from 'express';
import { createProductController } from '../controllers/productControllers.js';
import { upload } from '../config/multer.config.js';
import { handleMulterError, uploadToSupabase } from '../middlewares/multerMiddlewares.js';
import { productValidations } from '../middlewares/validateProduct.js';
import errorsIsEmpty from '../middlewares/errorIsEmpty.js';
import verifyToken from '../middlewares/validateToken.js';

const router = Router();

router.use(verifyToken);

router.post('/products', upload.single('imageUrl'), handleMulterError, uploadToSupabase, productValidations, errorsIsEmpty, createProductController);

export default router;
