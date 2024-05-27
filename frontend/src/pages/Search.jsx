import { useState, useEffect } from "react";
import styles, { layout } from "../style";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import SearchByImage from "../components/SearchByImage";
import SearchByTag from "../components/SearchByTag";
import DeleteImage from "../components/DeleteImage";
import DisplayImages from "../components/DisplayImages";
import UpdateTag from "../components/UpdateTag";
import { getCookie } from "../config/cookies";
import { landingPage } from "../components/Constants";
import { motion } from "framer-motion";

function Search() {
  const [searchResults, setSearchResults] = useState([]);
  const [selectedImage, setSelectedImage] = useState(null);
  const [searchState, setSearchState] = useState(false);
  const [isChecked, setIsChecked] = useState(false);

  const handleCheckboxChange = (event) => {
    setIsChecked(event.target.checked);
  };

  useEffect(() => {
    if (getCookie("id_token") == null) {
      alert("PLEASE LOGIN TO CONTINUE");
      window.location.replace(`${landingPage}`);
    }
  }, []);

  useEffect(() => {
    setSearchState(searchResults.length > 0);
  }, [searchResults]);

  return (
    <div className={`bg-[#020303] w-screen overflow-auto h-screen`}>
      <div className={`${styles.paddingX} ${styles.flexCenter}`}>
        <Navbar />
      </div>

      <div className={`bg-primary ${styles.paddingX} ${styles.flexCenter}`}>
        <div className={`${styles.boxWidth}`}>
          <section className={layout.section}>
            <div className={layout.sectionInfo}>
              <h2
                className={`${styles.heading2} ${styles.flexCenter} ${styles.boxWidth} ${styles.paddingY}`}
              >
                Toggle Search Mode
                <label
                  htmlFor="toggler"
                  className="bg-gray-700 cursor-pointer w-20 h-10 relative rounded-full mx-5"
                >
                  <input
                    type="checkbox"
                    id="toggler"
                    className="sr-only peer"
                    onChange={handleCheckboxChange}
                  />
                  <span
                    className="w-2/5 h-4/5 rounded-full flex left-1 top-1 transition-all duration-500
                  bg-[#9cf2d1] absolute peer-checked:bg-[#dbf6fa] peer-checked:left-11"
                  ></span>
                </label>
              </h2>

              {isChecked ? (
                <motion.div
                  initial={{ opacity: 0, height: 200 }}
                  animate={{ opacity: 1, height: 350 }}
                  transition={{ duration: 0.5 }}
                  className={`${styles.boxWidth}`}
                >
                  <h2
                    className={`${styles.heading2} ${styles.flexCenter} ${styles.boxWidth}`}
                  >
                    Search by Tag
                  </h2>
                  <div className={`${styles.flexCenter} ${styles.boxWidth}`}>
                    <SearchByTag setSearchResults={setSearchResults} />
                  </div>
                </motion.div>
              ) : (
                <motion.div
                  initial={{ opacity: 0, height: 350 }}
                  animate={{ opacity: 1, height: 200 }}
                  transition={{ duration: 0.5 }}
                  className={`${styles.boxWidth}`}
                >
                  <h2
                    className={`${styles.heading2} ${styles.flexCenter} ${styles.boxWidth}`}
                  >
                    Search by Image
                  </h2>
                  <div className={`${styles.flexCenter} ${styles.boxWidth}`}>
                    <SearchByImage setSearchResults={setSearchResults} />
                  </div>
                </motion.div>
              )}

              {searchState ? (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  transition={{ duration: 0.5 }}
                  className={`${styles.flexCenter} ${styles.boxWidth} flex-col pt-10`}
                >
                  <h2
                    className={`${styles.heading2} ${styles.flexCenter} ${styles.boxWidth}`}
                  >
                    Search Results
                  </h2>
                  <DisplayImages
                    searchResults={searchResults}
                    setSelectedImage={setSelectedImage}
                  />
                  {selectedImage ? (
                    <motion.div
                      initial={{ opacity: 0, height: 0 }}
                      animate={{ opacity: 1, height: "auto" }}
                      transition={{ duration: 0.5 }}
                    >
                      <DeleteImage
                        selectedImage={selectedImage}
                        setSelectedImage={setSelectedImage}
                      />
                      <div
                        className={`${styles.paragraph} ${styles.flexCenter} sm:my-6 my-6`}
                      >
                        OR
                      </div>
                      <UpdateTag selectedImage={selectedImage} />
                    </motion.div>
                  ) : null}
                </motion.div>
              ) : null}
            </div>
          </section>
        </div>
      </div>

      <div className={`bg-[#020303] ${styles.paddingX}`}>
        <Footer />
      </div>
    </div>
  );
}

export default Search;
