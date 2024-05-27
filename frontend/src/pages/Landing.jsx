import React from "react";
import { removeCookie } from "../config/cookies";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import styles from "../style";
import { loginURL } from "../components/Constants";

function Landing() {
  removeCookie("id_token");
  removeCookie("access_token");
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
          <p
            className={`${styles.paragraph} flex justify-center items-center ${styles.paddingY}`}
          >
            Please{" "}
            <a href={loginURL} className="hover:underline mx-1">
              login
            </a>{" "}
            to continue
          </p>
        </div>
      </div>

      <div className={`bg-[#020303] ${styles.paddingX}`}>
        <Footer />
      </div>
    </div>
  );
}

export default Landing;
