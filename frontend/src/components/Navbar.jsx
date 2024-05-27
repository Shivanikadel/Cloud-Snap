import logo from "../assets/logo.png";
import { getCookie } from "../config/cookies";
import { loginURL, logoutURL, signUpURL } from "./Constants";

const Navbar = () => {
  return (
    <nav className="w-full flex justify-between items-center navbar fixed top-0 left-0 bg-[#020303] sm:px-16 px-6">
      <a href="/">
        <img src={logo} alt="Cloud-Snap" className="w-[32px] h-[32px]" />
      </a>
      <ul className="list-none sm:flex justify-end items-center flex-1 ">
        <a href="/">
          <li className="cursor-pointer text-[16px] text-[#e2ecee] px-5 h-15 hover:bg-[#1f2323] hover:rounded-full py-6 items-center transition-all duration-300">
            Home
          </li>
        </a>
        <a href="/search">
          <li className="cursor-pointer text-[16px] text-[#e2ecee] px-5 h-15 hover:bg-[#1f2323] hover:rounded-full py-6 items-center transition-all duration-300">
            Search
          </li>
        </a>
        {getCookie("id_token") ? (
          <div className="flex justify-between items-center navbar">
            <a href={logoutURL}>
              <li className="cursor-pointer text-[16px] text-[#e2ecee] px-5 h-15 hover:bg-[#1f2323] hover:rounded-full py-6 items-center transition-all duration-300">
                Logout
              </li>
            </a>
          </div>
        ) : (
          <div className="flex justify-between items-center navbar">
            <a href={loginURL}>
              <li className="cursor-pointer text-[16px] text-[#e2ecee] px-5 h-15 hover:bg-[#1f2323] hover:rounded-full py-6 items-center transition-all duration-300">
                Login
              </li>
            </a>
            <a href={signUpURL}>
              <li className="cursor-pointer text-[16px] text-[#e2ecee] px-5 h-15 hover:bg-[#1f2323] hover:rounded-full py-6 items-center transition-all duration-300">
                Sign up
              </li>
            </a>
          </div>
        )}
      </ul>
    </nav>
  );
};

export default Navbar;
