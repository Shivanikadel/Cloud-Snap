import axiosClient from "../config/axiosClient";
import styles from "../style";
import { useState } from "react";

const DeleteImage = ({ selectedImage, setSelectedImage }) => {
  const [deleteStatus, setDeleteStatus] = useState(null);

  const handleDeleteImages = async () => {
    try {
      await axiosClient.delete("/api/image/", {
        data: { url: selectedImage },
      });
      setSelectedImage(null);
      setDeleteStatus("Image deleted successfully");
    } catch (error) {
      console.error("Error deleting image:", error);
      setDeleteStatus(`An error occurred while deleting the image: ${error}`);
    }
  };

  return (
    <section className={`${styles.flexCenter} flex-col`}>
      <button
        className="
            block w-1/3
            mr-4 py-2
            rounded-full border-0
            font-semibold
            bg-[#9cf2d1] text-[#040606]
            hover:bg-[#dbf6fa]
            "
        onClick={handleDeleteImages}
      >
        Delete Selected Image
      </button>
      {deleteStatus && (
        <p
          className={`mt-2 ${
            deleteStatus.includes("successfully") ? "text-green-300" : "text-rose-700"
          }`}
        >
          {deleteStatus}
        </p>
      )}
    </section>
  );
};

export default DeleteImage;
