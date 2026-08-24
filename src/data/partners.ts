import { coalitionStats } from '../coalition-stats';

// ─────────────────────────────────────────────────────────────
// FOUNDING COALITION — single source of truth for the partner list.
//
// The system grows: adding a founding partner = ONE entry here.
// No component edits, no rebuild of structure.
//
//   • anchorPartners → full logo + descriptor cards (the marquee names)
//   • wallPartners   → scalable logo wall below (holds 20–30+ cleanly)
//
// When a new org registers (Tally form → you approve), drop them into
// wallPartners with their logo file in /public/images/partners/.
// Promote an org to an anchor card only when it earns marquee placement.
// ─────────────────────────────────────────────────────────────

export interface AnchorPartner {
  name: string;
  url: string;
  logo: string;
  logoAlt: string;
  descriptor: string;
}

export interface WallPartner {
  name: string;
  url: string;
  logo: string;
  logoAlt: string;
}

export const anchorPartners: AnchorPartner[] = [
  {
    name: 'Homegrown National Park',
    url: 'https://homegrownnationalpark.org',
    logo: '/images/logo-hnp.webp',
    logoAlt: 'Homegrown National Park',
    descriptor: `The national movement for native habitat restoration, co-founded by Doug Tallamy — ${coalitionStats.acresPlanted} acres logged and growing.`,
  },
  {
    name: 'Doug Tallamy',
    url: 'https://homegrownnationalpark.org',
    logo: '/images/logo-udel-wordmark.webp',
    logoAlt: 'University of Delaware',
    descriptor:
      "The ecologist whose books Bringing Nature Home and Nature's Best Hope defined the native plant movement for a generation.",
  },
  {
    name: 'The Pollinator Pathway',
    url: 'https://www.pollinator-pathway.org',
    logo: '/images/logo-pollinator-pathway-icon.webp',
    logoAlt: 'The Pollinator Pathway',
    descriptor:
      'The grassroots network of pesticide-free native corridors spanning 300+ towns across 24 states and Canada.',
  },
  {
    name: 'University of Connecticut',
    url: 'https://uconn.edu',
    logo: '/images/logo-uconn-husky.png',
    logoAlt: 'University of Connecticut',
    descriptor:
      "Connecticut's flagship research university, backing this film through a grant championed by Dr. David Wagner.",
  },
  {
    name: 'New Directions in the American Landscape',
    url: 'https://www.ndal.org',
    logo: '/images/partners/ndal-logo.png',
    logoAlt: 'New Directions in the American Landscape',
    descriptor:
      "The ecological landscape design and stewardship education organization founded in 1990 by Larry Weaner — his daughter Sara Weaner Cooper, NDAL's principal, is one of the film's featured subjects.",
  },
];

// Growing roster — logos link out to each org (their backlink reward).
// Seed as orgs register and pass review. Empty is fine; the wall hides
// itself until the first partner lands here.
export const wallPartners: WallPartner[] = [];
