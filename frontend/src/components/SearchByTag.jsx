import { useState, useRef } from "react";
import styles from "../style";
import axiosClient from "../config/axiosClient";

const SearchByTag = ({ setSearchResults }) => {
  const [formFields, setFormFields] = useState([
    { tag: "", count: "" || undefined },
  ]);
  
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

  const handleSearchImages = async () => {
    try {
      const requestBody = {
        tags: formFields.map((tag) => ({
          tag: tag.tag,
          count: tag.count || undefined,
        })),
      };
      console.log(requestBody)
      const response = await axiosClient.post("/api/images/", requestBody);
      setSearchResults(response.data.links);
    } catch (error) {
      console.error("Error saving tags:", error);
    }
  };

  return (
    <div className={`${styles.paddingY}`}>
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
          <div className={`${styles.flexCenter} sm:my-2 my-2`}>
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
        {/* <form className={`${styles.flexCenter} w-40`}> */}
          <button
            className="
          block w-full
          mr-4 py-2
          rounded-full border-0
          font-semibold
          bg-[#9cf2d1] text-[#040606]
          hover:bg-[#dbf6fa]
          "
            onClick={handleSearchImages}
          >
            Search
          </button>
        {/* </form> */}
      </section>
    </div>
  );
};

export default SearchByTag;
