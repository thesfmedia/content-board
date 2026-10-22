# Content Board

A public board of video references. Anyone with the link can view it, and only you can sign in to add, tag, move or delete.

- **Hosting:** Vercel (free)
- **Videos, boards and tags:** Supabase (free tier: 1 GB of storage, 50 MB per file)

Setup takes about 15 minutes.

---

## 1. Create the database (Supabase)

1. Go to **supabase.com**, sign up, and click **New project**. Pick any name and password, and choose a region near you (Singapore or Mumbai works well from Pakistan).
2. When the project is ready, open **SQL Editor → New query**. Paste everything from `setup.sql` and click **Run**.
   - It is set up for `nayfus783926@gmail.com`. If you'll sign in with a different email, change it at the top of the file before running.
3. Open **Authentication → Users → Add user → Create new user**. Enter your email and a password, tick **Auto Confirm User**, then click **Create user**.
   - This is the only account that can edit.
4. Open **Authentication → Sign In / Providers** and turn off **Allow new users to sign up**. Even if someone else signs up, they can't edit anything, but this keeps things tidy.
5. Open **Project Settings → API** and copy:
   - the **Project URL**
   - the **anon public** key
6. Paste both into `config.js`.

## 2. Put it online (Vercel)

1. Go to **github.com**, create a new repository named something like `content-board`, then click **uploading an existing file**.
2. Drag in all four files: `index.html`, `config.js`, `setup.sql`, `README.md`. Click **Commit**.
3. Go to **vercel.com**, sign in with GitHub, click **Add New → Project**, pick the repo, and click **Deploy**. There are no settings to change.
4. You'll get a link like `content-board-xyz.vercel.app`. You can rename it under **Settings → Domains**.

## 3. Let Supabase know your link

In Supabase, open **Authentication → URL Configuration**:

1. Set **Site URL** to your Vercel link.
2. Add the same link to **Redirect URLs**, with `/**` on the end, for example `https://content-board-xyz.vercel.app/**`.

## 4. Start editing

1. Open your link and click **Sign in**.
2. Enter your email and open the link it sends you on the same device. You'll see **Add**, **+ Tag** and **+ New board** appear.
3. To get a share link for one board, choose it and press **Share**. Links look like `…vercel.app/?board=my-board`.

## How to use it

| Action | How |
|---|---|
| Add videos | Press **Add**, or drop files anywhere on the board. Vertical clips go to Short-form. |
| Save a YouTube, TikTok or Reels link | Press **Add → Save a link**. YouTube links show their thumbnail. |
| Mark status | Click a tile, then **To recreate** or **Remade** in the bar at the bottom. |
| Tag | Click a tile, then any tag in the bottom bar. Shift-click to select several tiles first. |
| Make or remove tags | Click **+ Tag** in the tag bar. |
| Move to another board | Select tiles, then use **Move to…** |
| Navigate | Drag or scroll to pan, pinch or ⌘/Ctrl-scroll to zoom, Shift+1 to fit. |

## Changing things later

Edit a file on GitHub (the pencil icon) and commit. Vercel redeploys within a minute.
