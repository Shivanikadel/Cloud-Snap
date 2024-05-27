import React from "react";
import ReactDOM from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import App from "./pages/App.jsx";
import "./index.css";
import SignedIn from "./pages/SignedIn.jsx";
import Search from "./pages/Search.jsx";
import Landing from "./pages/Landing.jsx";
import { getCookie } from "./config/cookies.jsx";

const router = createBrowserRouter([
  {
    path: "/landing",
    element: (
      <React.StrictMode>
        <Landing />
      </React.StrictMode>
    ),
  },

  {
    path: "/",
    element: (
      <React.StrictMode>
        {getCookie("id_token") ? <App /> : <Landing />}
      </React.StrictMode>
    ),
  },

  {
    path: "/signedin",
    element: (
      <React.StrictMode>
        <SignedIn />
      </React.StrictMode>
    ),
  },

  {
    path: "/search",
    element: (
      <React.StrictMode>
        <Search />
      </React.StrictMode>
    ),
  },
]);

ReactDOM.createRoot(document.getElementById("root")).render(
  <RouterProvider router={router} />
);
