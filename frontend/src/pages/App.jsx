import React from "react";
import styles from "../style";
import Navbar from "../components/Navbar";
import ImageUpload from "../components/imageUpload";
import Footer from "../components/Footer";
import { getCookie } from "../config/cookies";
import { useEffect } from "react";
import { landingPage } from "../components/Constants";

const App = () => {
  useEffect(() => {
    if (getCookie("id_token") == null) {
      alert("PLEASE LOGIN TO CONTINUE");
      window.location.replace(`${landingPage}`);
    }
  }, []);

  return (
    <div className={`bg-[#020303] w-screen overflow-auto h-screen pt-16`}>
      <div className={` ${styles.flexCenter} ${styles.paddingX} w-screen`}>
        <Navbar />
      </div>

      <div
        className={`bg-primary ${styles.flexCenter} ${styles.paddingY} ${styles.paddingY}`}
      >
        <div className={`${styles.boxWidth}`}>
          <h2 className={`${styles.heading2} ${styles.flexCenter}`}>
            Upload Image to S3
          </h2>
          <ImageUpload />
        </div>
      </div>

      <div className={` ${styles.paddingX} w-screen`}>
        <Footer />
      </div>
    </div>
  );
};

export default App;
