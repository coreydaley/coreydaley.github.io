/**
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-14T14:30:00-05:00
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

  // Check for New Year's Day (January 1)
  if (month === 1 && day === 1) {
    avatar.src = "/images/avatars/avatar-new-years.png";
    return;
  }

  // Check for Independence Day (July 4)
  if (month === 7 && day === 4) {
    avatar.src = "/images/avatars/avatar-independence-day.png";
    return;
  }

  // Check for Christmas (December 25)
  if (month === 12 && day === 25) {
    avatar.src = "/images/avatars/avatar-christmas.png";
    return;
  }

  // Check for St. Patrick's Day (March 17)
  if (month === 3 && day === 17) {
    avatar.src = "/images/avatars/avatar-st-patricks.png";
    return;
  }

  // Check for Birthday (March 1)
  if (month === 3 && day === 1) {
    avatar.src = "/images/avatars/avatar-birthday.png";
    return;
  }

  // Check for Valentine's Day (February 14)
  if (month === 2 && day === 14) {
    avatar.src = "/images/avatars/avatar-valentines.png";
    return;
  }

  // Check for Cinco de Mayo (May 5)
  if (month === 5 && day === 5) {
    avatar.src = "/images/avatars/avatar-cinco-de-mayo.png";
    return;
  }

  // Check for Memorial Day (last Monday of May)
  // Last Monday is always between May 25-31
  if (month === 5 && dayOfWeek === 1 && day >= 25 && day <= 31) {
    avatar.src = "/images/avatars/avatar-memorial.png";
    return;
  }

  // Check for Labor Day (1st Monday of September)
  // 1st Monday is always between Sept 1-7
  if (month === 9 && dayOfWeek === 1 && day >= 1 && day <= 7) {
    avatar.src = "/images/avatars/avatar-labor.png";
    return;
  }

  // Check for Halloween (October 31)
  if (month === 10 && day === 31) {
    avatar.src = "/images/avatars/avatar-halloween.png";
    return;
  }

  // Check for Veterans Day (November 11)
  if (month === 11 && day === 11) {
    avatar.src = "/images/avatars/avatar-veterans.png";
    return;
  }

  // Check for Thanksgiving (4th Thursday of November)
  // 4th Thursday is always between Nov 22-28
  if (month === 11 && dayOfWeek === 4 && day >= 22 && day <= 28) {
    avatar.src = "/images/avatars/avatar-thanksgiving.png";
    return;
  }

  // Check for Friday the 13th
  if (day === 13 && dayOfWeek === 5) {
    avatar.src = "/images/avatars/avatar-friday-13.png";
    return;
  }
}

// Initialize on DOM ready
document.addEventListener("DOMContentLoaded", checkSpecialDateAvatar);
