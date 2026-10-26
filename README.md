# Adrian 排课表 (Adrian's Lesson Timetable)

An open, real-time weekly timetable for Adrian's 学管 to check vacancies and add lessons.
**Anyone with the link can view and add lessons — no login, no VPN needed (HK / overseas).**

- Weekly grid, Mon–Sat 09:00–21:00 (Sundays closed)
- Click any vacant slot to add a lesson: 学管 name, student, programme (紫荆 / 跃升 / 灯塔), date & time, subject, and **固排** (weekly recurring, shown with a 固排 tag)
- Colours: purple = 紫荆 · dark blue = 跃升/灯塔 · orange = 扬帆 (group class) · black = Adrian's blocked time
- Conflict blocking: overlapping bookings are refused automatically
- Live sync between everyone's browsers

Stack: one static `index.html` (GitHub Pages) + a free [Supabase](https://supabase.com) database. MIT licensed — fork freely.

---

## Setup (once, ~10 minutes)

### 1. Create the database (Supabase)

1. Go to **supabase.com → Start your project → Continue with GitHub** (uses your existing GitHub account).
2. **New project** → name it `adrian-timetable`, pick the **Singapore** region (closest to HK), set any database password (you won't need it again) → **Create**.
3. Wait ~1 min for the project to provision.
4. Left sidebar → **SQL Editor → New query** → paste the entire contents of **`setup.sql`** → **Run**.
   This creates the tables, opens access, and loads the current 固定排课 + 学管 list.
5. Left sidebar → **Project Settings → API**. Copy two values:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **anon / public key** (long string starting `eyJ...`)

### 2. Configure the site

Open `index.html` and near the top of the `<script>` section replace:

```js
const SUPABASE_URL      = "PASTE_YOUR_SUPABASE_URL_HERE";
const SUPABASE_ANON_KEY = "PASTE_YOUR_SUPABASE_ANON_KEY_HERE";
```

with your two values from step 1.5. (The anon key is designed to be public — it only grants what the database policies allow.)

### 3. Publish on GitHub Pages

1. On GitHub: **New repository** → name `adrian-timetable` → Public → Create.
2. Upload `index.html`, `setup.sql`, `README.md` (drag-and-drop on the repo page → Commit).
3. Repo → **Settings → Pages** → Source: **Deploy from a branch** → Branch: `main`, folder `/ (root)` → **Save**.
4. After ~1 minute your site is live at:

   `https://<your-github-username>.github.io/adrian-timetable/`

Send that link to your 学管. Done.

---

## Day-to-day

- **Add a lesson**: click a vacant slot (or ＋加课), fill the form. Tick **固排吗** to repeat weekly from that date.
- **New 学管**: in the 学管 dropdown choose「＋ 我是新学管」and type the name — it's saved for everyone.
- **Cancel a lesson**: click it → 删除此课 → confirm. Deleting a 固排 removes it for every week.
- **Change the fixed schedule**: just delete the old entry on the site and add a new one.

## Notes & limits

- **Open by design**: anyone who has the link can add *and delete* lessons. That's the requested behaviour — only share the link with 学管.
- Mainland China access is **not** guaranteed (`github.io` can be unstable there). All current 学管 are in HK/overseas, so this is fine; revisit hosting if that changes.
- Supabase free tier is far beyond what a timetable needs; it pauses projects after ~1 week of **zero** activity — normal daily use keeps it awake, and it can be restored from the dashboard if it ever pauses.
