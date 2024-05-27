import axios from "axios";
import { getCookie } from "./cookies";
import { apiEndpoint } from "../components/Constants";

const baseURL = `${apiEndpoint}`;

const axiosClient = axios.create({
  baseURL,
  headers: {
    "Content-Type": "application/json",
    Authorization: getCookie("id_token"),
  },
});

export default axiosClient;
