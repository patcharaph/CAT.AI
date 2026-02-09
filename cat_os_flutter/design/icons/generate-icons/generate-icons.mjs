import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import sharp from "sharp";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const iconsRoot = path.resolve(__dirname, "..");
const projectRoot = path.resolve(iconsRoot, "..", "..");

const defaultSourceSvg = path.resolve(iconsRoot, "source", "icon-svg-base.svg");
const inputSvg = process.argv[2]
  ? path.resolve(process.cwd(), process.argv[2])
  : defaultSourceSvg;

const jobs = [
  {
    name: "web/favicon",
    out: path.resolve(projectRoot, "web", "favicon.png"),
    size: 32,
  },
  {
    name: "web/icon-192",
    out: path.resolve(projectRoot, "web", "icons", "Icon-192.png"),
    size: 192,
  },
  {
    name: "web/icon-512",
    out: path.resolve(projectRoot, "web", "icons", "Icon-512.png"),
    size: 512,
  },
  {
    name: "web/icon-maskable-192",
    out: path.resolve(projectRoot, "web", "icons", "Icon-maskable-192.png"),
    size: 192,
    paddingRatio: 0.1,
  },
  {
    name: "web/icon-maskable-512",
    out: path.resolve(projectRoot, "web", "icons", "Icon-maskable-512.png"),
    size: 512,
    paddingRatio: 0.1,
  },
  {
    name: "android/mdpi",
    out: path.resolve(
      projectRoot,
      "android",
      "app",
      "src",
      "main",
      "res",
      "mipmap-mdpi",
      "ic_launcher.png",
    ),
    size: 48,
  },
  {
    name: "android/hdpi",
    out: path.resolve(
      projectRoot,
      "android",
      "app",
      "src",
      "main",
      "res",
      "mipmap-hdpi",
      "ic_launcher.png",
    ),
    size: 72,
  },
  {
    name: "android/xhdpi",
    out: path.resolve(
      projectRoot,
      "android",
      "app",
      "src",
      "main",
      "res",
      "mipmap-xhdpi",
      "ic_launcher.png",
    ),
    size: 96,
  },
  {
    name: "android/xxhdpi",
    out: path.resolve(
      projectRoot,
      "android",
      "app",
      "src",
      "main",
      "res",
      "mipmap-xxhdpi",
      "ic_launcher.png",
    ),
    size: 144,
  },
  {
    name: "android/xxxhdpi",
    out: path.resolve(
      projectRoot,
      "android",
      "app",
      "src",
      "main",
      "res",
      "mipmap-xxxhdpi",
      "ic_launcher.png",
    ),
    size: 192,
  },
  {
    name: "exports/web/favicon",
    out: path.resolve(iconsRoot, "exports", "web", "favicon-32.png"),
    size: 32,
  },
  {
    name: "exports/web/icon-192",
    out: path.resolve(iconsRoot, "exports", "web", "icon-192.png"),
    size: 192,
  },
  {
    name: "exports/web/icon-512",
    out: path.resolve(iconsRoot, "exports", "web", "icon-512.png"),
    size: 512,
  },
  {
    name: "exports/android/ic_launcher-mdpi",
    out: path.resolve(iconsRoot, "exports", "android", "ic_launcher-mdpi.png"),
    size: 48,
  },
  {
    name: "exports/android/ic_launcher-hdpi",
    out: path.resolve(iconsRoot, "exports", "android", "ic_launcher-hdpi.png"),
    size: 72,
  },
  {
    name: "exports/android/ic_launcher-xhdpi",
    out: path.resolve(iconsRoot, "exports", "android", "ic_launcher-xhdpi.png"),
    size: 96,
  },
  {
    name: "exports/android/ic_launcher-xxhdpi",
    out: path.resolve(iconsRoot, "exports", "android", "ic_launcher-xxhdpi.png"),
    size: 144,
  },
  {
    name: "exports/android/ic_launcher-xxxhdpi",
    out: path.resolve(iconsRoot, "exports", "android", "ic_launcher-xxxhdpi.png"),
    size: 192,
  },
  {
    name: "exports/store/play-icon-512",
    out: path.resolve(iconsRoot, "exports", "store", "play-icon-512.png"),
    size: 512,
  },
];

async function ensureFileExists(filePath) {
  try {
    await fs.access(filePath);
  } catch {
    throw new Error(
      `SVG base not found at "${filePath}". Create "icon-svg-base.svg" first.`,
    );
  }
}

async function renderPng(svgBuffer, job) {
  const { size, out, paddingRatio = 0 } = job;
  await fs.mkdir(path.dirname(out), { recursive: true });

  if (paddingRatio > 0) {
    const inner = Math.round(size * (1 - paddingRatio * 2));
    const offset = Math.floor((size - inner) / 2);
    const iconBuffer = await sharp(svgBuffer)
      .resize(inner, inner, {
        fit: "contain",
        background: { r: 0, g: 0, b: 0, alpha: 0 },
      })
      .png()
      .toBuffer();

    await sharp({
      create: {
        width: size,
        height: size,
        channels: 4,
        background: { r: 0, g: 0, b: 0, alpha: 0 },
      },
    })
      .composite([{ input: iconBuffer, left: offset, top: offset }])
      .png()
      .toFile(out);
    return;
  }

  await sharp(svgBuffer)
    .resize(size, size, {
      fit: "contain",
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toFile(out);
}

async function main() {
  await ensureFileExists(inputSvg);
  const svgBuffer = await fs.readFile(inputSvg);

  console.log(`Generating icons from: ${inputSvg}`);
  for (const job of jobs) {
    await renderPng(svgBuffer, job);
    console.log(`- ${job.name} -> ${path.relative(projectRoot, job.out)}`);
  }
  console.log("Done.");
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
