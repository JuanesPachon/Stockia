import { Types } from "mongoose";

declare global {
  namespace Express {
    interface Request {
      user?: {
        sub: string;
        iat: number;
      };
    }
  }
}

export {};