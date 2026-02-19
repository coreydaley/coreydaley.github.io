/**
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-14T14:30:00-05:00
 * Last Modified By: Claude Code (Claude Sonnet 4.6)
 * Last Modified: 2026-02-18T00:00:00-05:00
 */

// Special Date Avatar Swapping
// Automatically changes the site avatar based on holidays and special dates

/**
 * Checks the current date and updates the avatar if it matches a special date/holiday
 * @returns {void}
 */
function checkSpecialDateAvatar() {
  const avatar = document.getElementById("site-avatar");
  if (!avatar) return;

  const now = new Date();
  const month = now.getMonth() + 1; // getMonth() returns 0-11
  const day = now.getDate();
  const dayOfWeek = now.getDay(); // 0 = Sunday, 4 = Thursday, 5 = Friday
  const cacheKey = `special-avatar-${now.getFullYear()}-${month}-${day}`;

  // Return cached result if available for today
  try {
    const cached = localStorage.getItem(cacheKey);
    if (cached !== null) {
      if (cached) {
        const { src, alt } = JSON.parse(cached);
        avatar.src = src;
        avatar.alt = alt;
      }
      return;
    }
  } catch (_) {
    /* ignore storage errors */
  }

  // Compute special date avatar
  let src = null;
  let alt = null;

  if (month === 1 && day === 1) {
    src = "/images/avatars/avatar-newyears.png";
    alt = "Profile avatar celebrating New Year's Day";
  } else if (month === 2 && day === 14) {
    src = "/images/avatars/avatar-valentines.png";
    alt = "Profile avatar celebrating Valentine's Day";
  } else if (month === 3 && day === 1) {
    src = "/images/avatars/avatar-birthday.png";
    alt = "Profile avatar celebrating a birthday";
  } else if (month === 3 && day === 17) {
    src = "/images/avatars/avatar-stpatricks.png";
    alt = "Profile avatar celebrating St. Patrick's Day";
  } else if (month === 5 && day === 5) {
    src = "/images/avatars/avatar-cincodemayo.png";
    alt = "Profile avatar celebrating Cinco de Mayo";
  } else if (month === 5 && dayOfWeek === 1 && day >= 25 && day <= 31) {
    src = "/images/avatars/avatar-memorial.png";
    alt = "Profile avatar honoring Memorial Day";
  } else if (month === 7 && day === 4) {
    src = "/images/avatars/avatar-independence-day.png";
    alt = "Profile avatar celebrating Independence Day";
  } else if (month === 9 && dayOfWeek === 1 && day >= 1 && day <= 7) {
    src = "/images/avatars/avatar-labor.png";
    alt = "Profile avatar celebrating Labor Day";
  } else if (month === 10 && day === 31) {
    src = "/images/avatars/avatar-halloween.png";
    alt = "Profile avatar dressed up for Halloween";
  } else if (month === 11 && day === 11) {
    src = "/images/avatars/avatar-veterans.png";
    alt = "Profile avatar honoring Veterans Day";
  } else if (month === 11 && dayOfWeek === 4 && day >= 22 && day <= 28) {
    src = "/images/avatars/avatar-thanksgiving.png";
    alt = "Profile avatar celebrating Thanksgiving";
  } else if (month === 12 && day === 25) {
    src = "/images/avatars/avatar-christmas.png";
    alt = "Profile avatar celebrating Christmas";
  } else if (day === 13 && dayOfWeek === 5) {
    src = "/images/avatars/avatar-friday13.png";
    alt = "Profile avatar themed for Friday the 13th";
  }

  // Cache result — empty string means no special date today
  try {
    localStorage.setItem(cacheKey, src ? JSON.stringify({ src, alt }) : "");
  } catch (_) {
    /* ignore storage errors */
  }

  if (src) {
    avatar.src = src;
    avatar.alt = alt;
  }
}

// Initialize on DOM ready
document.addEventListener("DOMContentLoaded", checkSpecialDateAvatar);
