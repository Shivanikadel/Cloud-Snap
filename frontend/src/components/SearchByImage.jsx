import { useState, useRef } from "react";
import styles from "../style";
import axiosClient from "../config/axiosClient";

const SearchByImage = ({ setSearchResults }) => {
  const [selectedFile, setSelectedFile] = useState(null);
  const imageRef = useRef(null);

  const handleFileSelect = async (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleUpload = () => {
    if (selectedFile) {
      const reader = new FileReader();
      reader.readAsDataURL(selectedFile);

      reader.onloadend = async () => {
        const base64Data = reader.result.split(",")[1];
        try {
          const response = await axiosClient.post("/api/images/", {
            data: { image: base64Data },
          });
          setSearchResults(response.data.links);
          console.log(`Image uploaded successfully. ${base64Data}`);
        } catch (error) {
          console.error("Error occurred while uploading the image:", error);
        }
      };

      imageRef.current.value = "";
      setSelectedFile(null);
    } else console.log("No file has been uploaded");
  };
  return (
    <section className={`${styles.flexCenter} ${styles.paddingY} flex-col`}>
      <div className="flex items-center space-x-6">
        <label className="block">
          <input
            type="file"
            accept="image/*"
            ref={imageRef}
            className="
            block w-full text-sm text-slate-500
            file:mr-4 file:py-2 file:px-4
            file:rounded-full file:border-0
            file:text-sm file:font-semibold
            file:bg-[#9cf2d1] file:text-[#040606]
            hover:file:bg-[#dbf6fa]
            "
            onChange={handleFileSelect}
          />
        </label>
        <button
          className="text-[#e2ecee] rounded-full mr-4 py-1 px-3 outline outline-[#dbf6fa]"
          onClick={handleUpload}
        >
          Search
        </button>
      </div>
    </section>
  );
};

export default SearchByImage;
