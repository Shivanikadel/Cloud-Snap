import React, { useEffect } from "react";
import Navbar from "../components/Navbar";
import styles from "../style";
import Footer from "../components/Footer";
import { setCookie } from "../config/cookies";

function SignedIn() {
  useEffect(() => {
    const queryParams = window.location.href;
    const urlParams = new URLSearchParams(queryParams.split("#")[1]);
    const accessToken = urlParams.get("access_token");
    const idToken = urlParams.get("id_token");
    const expiresIn = urlParams.get("expires_in");
    const tokenExpiry = new Date(Date.now() + parseInt(expiresIn) * 1000);

    if (accessToken != null) {
      setCookie("access_token", accessToken, {
        path: "/",
        expires: tokenExpiry,
      });
    }

    if (idToken != null) {
      setCookie("id_token", idToken, { path: "/", expires: tokenExpiry });
    } else {
      console.log("Error fetching login details");
    }
    window.history.replaceState({}, document.title, window.location.pathname);
  }, []);

  return (
    <div className={`bg-[#020303] w-screen overflow-auto h-screen pt-16`}>
      <div className={` ${styles.flexCenter} ${styles.paddingX} w-screen`}>
        <Navbar />
      </div>

      <div className={`bg-primary ${styles.flexCenter}`}>
        <div className={`${styles.boxWidth} ${styles.paddingY}`}>
          <h2 className={`${styles.heading2} ${styles.flexCenter}`}>
            Welcome to Cloud Snap
          </h2>
          <div className="flex-wrap flex items-center justify-center py-8">
            <a
              href="/"
              className="block max-w-sm p-6 rounded-lg shadow bg-[#040606] border-gray-700 hover:bg-[#1f2323] h-[150px]"
            >
              <h5 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                Feature 1: Upload Image
              </h5>
              <p className="font-normal text-gray-700 dark:text-gray-400">
                This feature enables you to upload any image of your choosing
                directly to the server.
              </p>
            </a>
            <a
              href="/search"
              className="block max-w-sm p-6 rounded-lg shadow bg-[#040606] border-gray-700 hover:bg-[#1f2323] h-[150px]"
            >
              <h5 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                Feature 2: Search for Image
              </h5>
              <p className="font-normal text-gray-700 dark:text-gray-400">
                This feature enables you to search for any image using tags and
                counts or using tags provided by uploading another image.
              </p>
            </a>
            <a
              href="/search"
              className="block max-w-sm p-6 rounded-lg shadow bg-[#040606] border-gray-700 hover:bg-[#1f2323] h-[150px]"
            >
              <h5 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                Feature 3: Delete Image
              </h5>
              <p className="font-normal text-gray-700 dark:text-gray-400">
                This feature enables you to delete any already uploaded image
                from the server. It requires you to select an image after
                searching first.
              </p>
            </a>
            <a
              href="/search"
              className="block max-w-sm p-6 rounded-lg shadow bg-[#040606] border-gray-700 hover:bg-[#1f2323] h-full"
            >
              <h5 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                Feature 4: Update Image Tags
              </h5>
              <p className="font-normal dark:text-gray-400">
                This feature enables you to update tags for an already upload
                image. You can choose to either delete or add a tag. It requires
                you to select an image after searching first.
              </p>
            </a>
          </div>
        </div>
      </div>

      <div className={` ${styles.paddingX} w-screen`}>
        <Footer />
      </div>
    </div>
  );
}

export default SignedIn;
