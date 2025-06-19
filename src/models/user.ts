import { ObjectId } from "mongodb";

export default interface User {
    name: string;
    surname: string;
    email: string;   
    id?: ObjectId;
}