import { useRef, useState } from "react";
import axiosClient from "../config/axiosClient";
import styles from "../style";

function ImageUpload() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [uploadStatus, setUploadStatus] = useState(null);
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
          await axiosClient.post("/api/image/", { image: base64Data });
          console.log(`Image uploaded successfully. ${base64Data}`);
          setUploadStatus("Image uploaded successfully");
        } catch (error) {
          console.error("Error occurred while uploading the image:", error);
          setUploadStatus(`Error uploading Image: ${error}`);
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
            className="block w-full text-sm text-slate-500
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
          Upload
        </button>
      </div>
      {uploadStatus && (
        <p
          className={`mt-2 ${
            uploadStatus.includes("successfully") ? "text-green-300" : "text-rose-700"
          } ${styles.flexCenter}`}
        >
          {uploadStatus}
        </p>
      )}
    </section>
  );
}

export default ImageUpload;
