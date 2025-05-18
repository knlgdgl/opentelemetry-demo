import { render, screen } from '@testing-library/react';
import Banner from '../Banner';

describe('Banner component', () => {
  it('renders the banner title correctly', () => {
    const expectedText = 'NEW CHANGE COMMITTED FROM GIT!!! The best telescopes to see the world closer';
    render(<Banner />);
    expect(screen.getByText(expectedText)).toBeInTheDocument();
  });
});
