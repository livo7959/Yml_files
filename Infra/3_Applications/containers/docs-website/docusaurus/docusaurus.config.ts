import type * as Preset from "@docusaurus/preset-classic";
import type { Config } from "@docusaurus/types";
import { themes as prismThemes } from "prism-react-renderer";

const config: Config = {
  title: "LogixHealth Docs",
  tagline: "Making Intelligence Matter",
  favicon: "img/favicon.ico",
  url: "https://docs.logixhealth.com",
  baseUrl: "/",

  onBrokenAnchors: "throw",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "throw",
  onDuplicateRoutes: "throw",

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          editUrl:
            "https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure?path=/",
          routeBasePath: "/",
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: "img/docusaurus-social-card.jpg",
    navbar: {
      title: "LogixHealth Docs",
      logo: {
        alt: "LogixHealth Logo",
        src: "img/logixhealth.png",
      },
      items: [
        {
          href: "https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure?path=/docs",
          label: "Azure DevOps",
          position: "right",
        },
      ],
    },
    colorMode: {
      defaultMode: "dark",
    },

    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,

  future: {
    experimental_faster: true,
  },
};

export default config;
