import { useState } from "react";
import axiosClient from "../config/axiosClient";
import styles from "../style";

const UpdateTag = ({ selectedImage }) => {
  const [tagType, setTagType] = useState(0);
  const [formFields, setFormFields] = useState([
    { tag: "", count: "" || undefined },
  ]);
  const [updateStatus, setUpdateStatus] = useState(null);

  const handleOnTextChange = (event, index) => {
    let data = [...formFields];
    data[index][event.target.name] = event.target.value;
    setFormFields(data);
  };

  const addFields = () => {
    setFormFields((prevFields) => [...prevFields, { tag: "", count: "" }]);
  };

  const removeFields = (index) => {
    setFormFields((prevFields) => {
      const updatedFields = [...prevFields];
      updatedFields.splice(index, 1);
      return updatedFields;
    });
  };

  const handleSaveTags = async () => {
    try {
      const payload = {
        url: selectedImage,
        type: tagType,
        tags: formFields.map((tag) => ({
          tag: tag.tag,
          count: tag.count || undefined,
        })),
      };
      await axiosClient.post("/api/tags/", payload);
      setUpdateStatus("Tag Updated successfully");
    } catch (error) {
      console.error("Error saving tags:", error);
      setUpdateStatus(`Error updating tag: ${error}`);
    }
  };

  return (
    <div>
      <div className={`w-full justify-center items-center flex`}>
        <div>
          {formFields.map((form, index) => {
            return (
              <div key={index} className={`${styles.flexCenter}`}>
                <input
                  name="tag"
                  placeholder="Tag"
                  value={form.tag}
                  onChange={(event) => handleOnTextChange(event, index)}
                  className="block w-1/3 p-4 pl-10 text-sm text-gray-900 border border-gray-300 
                  rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 
                dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 
                dark:focus:border-blue-500 h-10"
                />
                <input
                  name="count"
                  placeholder="Count"
                  onChange={(event) => handleOnTextChange(event, index)}
                  value={form.count}
                  className="block w-1/3 p-4 pl-10 text-sm text-gray-900 border border-gray-300 
                  rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 
                dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 
                dark:focus:border-blue-500 mx-1 h-10"
                />
                <button
                  className="sm:my-1.5 my-1.5 text-[#e2ecee] rounded-full mr-4 py-1 px-3 outline outline-[#dbf6fa] h-10 sm:mx-2 mx-2 "
                  onClick={() => removeFields(index)}
                >
                  Remove Tag
                </button>
              </div>
            );
          })}
          <div className={`flex justify-center items-center sm:my-2 my-2 `}>
            <button
              className="sm:my-2 my-2 text-[#e2ecee] rounded-full mr-4 py-1 px-3 outline outline-[#dbf6fa] w-1/7 h-10"
              onClick={addFields}
            >
              Add More Tags
            </button>
          </div>
        </div>
      </div>
      <section className={`w-full ${styles.flexCenter} sm:my-5 my-5`}>
        <div
          className={`pl-4 border border-gray-200 rounded dark:border-gray-700 w-1/3 h-10 sm:mx-3 mx-3 ${styles.flexCenter}`}
        >
          <input
            type="radio"
            value=""
            name="bordered-radio"
            defaultChecked
            onClick={() => setTagType(0)}
            className="w-8 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          />
          <label
            htmlFor="bordered-radio-1"
            className="w-full py-4 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
          >
            Add Tag
          </label>
        </div>
        <div
          className={`pl-4 border border-gray-200 rounded dark:border-gray-700 w-40 h-10 pr-4 ${styles.flexCenter}`}
        >
          <input
            type="radio"
            value=""
            name="bordered-radio"
            onClick={() => setTagType(1)}
            className="w-8 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          />
          <label
            htmlFor="bordered-radio-2"
            className="w-full py-4 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300 px-1"
          >
            Remove Tag
          </label>
        </div>
        <form className={`${styles.flexCenter} w-40 mx-2`}>
          <button
            className="
            block w-full
            mx-4 py-2
            rounded-full border-0
            font-semibold
            bg-[#9cf2d1] text-[#040606]
            hover:bg-[#dbf6fa]
            "
            onClick={handleSaveTags}
          >
            Update Tag
          </button>
        </form>
      </section>
      {updateStatus && (
        <p
          className={`${
            updateStatus.includes("successfully") ? "text-green-300" : "text-rose-700"
          } ${styles.flexCenter}`}
        >
          {updateStatus}
        </p>
      )}
    </div>
  );
};

export default UpdateTag;
