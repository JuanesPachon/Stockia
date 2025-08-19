import { Types } from "mongoose";
import { IMulterFile } from "../interfaces/multer.interface";

declare global {
  namespace Express {
    interface Request {
      user?: {
        sub: string;
        iat: number;
      };
      file?: IMulterFile;
    }
  }
}

export {};