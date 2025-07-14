import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  image:{
    remotePatterns:[
      {
        protocol:'https',
        hostname:'picsum.photos'
      },
    ],
  }
};

export default nextConfig;
