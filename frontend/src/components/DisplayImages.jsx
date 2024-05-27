import React from "react";
import styles from "../style";

const DisplayImages = ({ searchResults, setSelectedImage }) => {
  const handleRadioChange = (event, imageURL) => {
    if (event.target.checked) {
      setSelectedImage(imageURL);
      console.log(imageURL);
    } else {
      setSelectedImage(null);
    }
  };

  return (
    <section className={`${styles.flexCenter} ${styles.marginY} flex-col`}>
      <ul className={`flex-wrap gap-6 ${styles.flexCenter} `}>
        {searchResults.map((link, index) => (
          <li key={index} className={`${styles.flexCenter}`}>
            <input
              id={link}
              type="radio"
              name="selectedImage"
              onChange={(event) => handleRadioChange(event, link)}
              className="hidden peer"
              value={link}
            />
            <label
              className="inline-flex items-center justify-between w-full p-5
                text-gray-500 bg-white border-2 border-gray-200 rounded-lg cursor-pointer 
                dark:hover:text-gray-300 dark:border-gray-700 peer-checked:border-[#9ce8f2]
                hover:text-gray-600 dark:peer-checked:text-gray-300 peer-checked:text-gray-600
                hover:bg-gray-50 dark:text-gray-400 dark:bg-gray-800 dark:hover:bg-gray-700"
              htmlFor={link}
            >
              <div className="block">
                <img src={link} alt={`Image ${index + 1}`} />
              </div>
            </label>
          </li>
        ))}
      </ul>
    </section>
  );
};

export default DisplayImages;
